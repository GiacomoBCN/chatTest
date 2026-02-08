import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/message.dart';
import 'confidence_indicator.dart';
import 'source_attribution.dart';
import 'uncertainty_bar.dart';
import 'tier_badge.dart';
import 'streaming_indicator.dart';
import 'expandable_section.dart';
import 'accountability_checkpoint.dart';
import 'human_handoff.dart';
import 'customer_profile_card.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;

  const MessageBubble({
    super.key,
    required this.message,
    this.onApprove,
    this.onDecline,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.animationFast,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get isUser => widget.message.type == MessageType.user;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingMedium,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) _buildAvatar(),
              if (!isUser) const SizedBox(width: 8),
              Flexible(
                child: _buildMessageContent(),
              ),
              if (isUser) const SizedBox(width: 8),
              if (isUser) _buildAvatar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Semantics(
      label: isUser ? 'Your message' : 'AI Assistant message',
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isUser
              ? AppTheme.primaryBurgundy
              : AppTheme.primaryBurgundy.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isUser ? Icons.person : Icons.smart_toy,
          color: isUser ? Colors.white : AppTheme.primaryBurgundy,
          size: 22,
          semanticLabel: isUser ? 'User' : 'AI Assistant',
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: isUser ? AppTheme.primaryBurgundy : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppTheme.borderRadiusLarge),
          topRight: const Radius.circular(AppTheme.borderRadiusLarge),
          bottomLeft: Radius.circular(isUser ? AppTheme.borderRadiusLarge : 4),
          bottomRight: Radius.circular(isUser ? 4 : AppTheme.borderRadiusLarge),
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tier badge
          if (widget.message.tierLevel != null) ...[
            TierBadge(
              tier: widget.message.tierLevel!,
              customLabel: widget.message.tierLabel,
            ),
            const SizedBox(height: 12),
          ],
          // Streaming indicator
          if (widget.message.isStreaming &&
              widget.message.streamingSteps != null) ...[
            StreamingIndicator(steps: widget.message.streamingSteps!),
            const SizedBox(height: 12),
          ],
          // Main content
          if (!widget.message.isStreaming ||
              widget.message.streamingSteps?.every((s) => s.isComplete) ==
                  true)
            Text(
              widget.message.content,
              style: TextStyle(
                fontSize: AppTheme.fontSizeBody,
                color: isUser ? Colors.white : AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
          // Warning message
          if (widget.message.warningMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.warning.withOpacity(0.15),
                borderRadius:
                    BorderRadius.circular(AppTheme.borderRadiusSmall),
                border: Border.all(color: AppTheme.warning.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: AppTheme.warning,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.message.warningMessage!,
                      style: const TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Customer profile
          if (widget.message.customerProfile != null) ...[
            const SizedBox(height: 12),
            CustomerProfileCard(profile: widget.message.customerProfile!),
          ],
          // Confidence indicator
          if (widget.message.confidencePercent != null &&
              widget.message.confidenceLevel != null &&
              !widget.message.isStreaming) ...[
            const SizedBox(height: 12),
            ConfidenceIndicator(
              confidencePercent: widget.message.confidencePercent!,
              level: widget.message.confidenceLevel!,
            ),
          ],
          // Uncertainty bar
          if (widget.message.uncertaintyData != null) ...[
            const SizedBox(height: 12),
            UncertaintyBar(data: widget.message.uncertaintyData!),
          ],
          // Source attribution
          if (widget.message.sources != null &&
              widget.message.sources!.isNotEmpty) ...[
            const SizedBox(height: 12),
            SourceAttribution(sources: widget.message.sources!),
          ],
          // ML Reasoning
          if (widget.message.mlReasoning != null) ...[
            const SizedBox(height: 12),
            ExpandableSection(
              title: 'Show ML reasoning',
              reasoning: widget.message.mlReasoning!,
            ),
          ],
          // Human handoff
          if (widget.message.showHumanHandoff) ...[
            const SizedBox(height: 12),
            HumanHandoff(
              title: 'Connect with a Specialist',
              message:
                  'Your inquiry requires personalized guidance from our lending experts.',
              explanation:
                  'Loan recommendations involve complex factors including your financial situation, goals, and risk tolerance. Our specialists can provide tailored advice that AI cannot.',
              onScheduleCall: () {},
              onLiveChat: () {},
            ),
          ],
          // Accountability checkpoint
          if (widget.message.showAccountabilityCheckpoint) ...[
            const SizedBox(height: 12),
            AccountabilityCheckpoint(
              onApprove: widget.onApprove,
              onDecline: widget.onDecline,
            ),
          ],
          // Action buttons
          if (widget.message.actionButtons != null &&
              widget.message.actionButtons!.isNotEmpty &&
              !widget.message.isStreaming) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.message.actionButtons!.map((label) {
                return OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        isUser ? Colors.white : AppTheme.primaryBurgundy,
                    side: BorderSide(
                      color: isUser
                          ? Colors.white.withOpacity(0.5)
                          : AppTheme.primaryBurgundy,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: AppTheme.fontSizeSmall),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
